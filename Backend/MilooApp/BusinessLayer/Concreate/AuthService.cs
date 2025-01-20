using BusinessLayer.Abstract;
using BusinessLayer.Abstract.Token;
using BusinessLayer.Dtos.AuthDtos;
using BusinessLayer.Dtos.TokenDtos;
using BusinessLayer.Helpers;
using BusinessLayer.Helpers.EmailHelper;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using FluentValidation;
using Google.Apis.Auth;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.Security.Cryptography;

namespace BusinessLayer.Concreate
{
    public class AuthService : IAuthService
    {
        private readonly IUserRepository _repository;
        private readonly ITokenHandler _tokenHandler;
        private readonly IValidator<LoginUserRequest> _loginValidator;
        private readonly IValidator<RegisterUserRequest> _registerValidator;
        private readonly IEmailHelper _emailHelper;
        private readonly IConfiguration _configuration;
        private readonly IUserRoleRepository _userRoleRepository;

        public AuthService(IUserRepository repository, ITokenHandler tokenHandler, IValidator<LoginUserRequest> loginValidator, IValidator<RegisterUserRequest> registerValidator, IEmailHelper emailHelper, IConfiguration configuration, IUserRoleRepository userRoleRepository)
        {
            _repository = repository;
            _tokenHandler = tokenHandler;
            _loginValidator = loginValidator;
            _registerValidator = registerValidator;
            _emailHelper = emailHelper;
            _configuration = configuration;
            _userRoleRepository = userRoleRepository;
        }

        public async Task<BaseResponse> RegisterAsync(RegisterUserRequest request)
        {
            await _registerValidator.ValidateAndThrowAsync(request);

            User user = new()
            {
                FirstName = request.FirstName,
                LastName = request.LastName,
                UniversityId = request.UniversityId,
                Email = request.Email,
                UserName = request.UserName,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                EmailVerificationCode = GenerateVerificationCode(),
                EmailVerificationCodeExpiresOn = DateTime.Now.AddMinutes(15),
                UserPhotos = new List<UserPhoto> { new UserPhoto { ImagePath = "defaulProfilePhoto.png", isProfilePhoto = true } },
                UserRoles = new List<UserRole>()
                {
                    new UserRole()
                    {
                        RoleId = 2 ,
                    }
                }
            };

            bool isAdd = await _repository.AddAsync(user);

            if (!isAdd)
            {
                throw new Exception("Kullanıcı eklenirken bir hata oluştu.");
            }


            // Doğrulama emailini gönder
            await _emailHelper.SendVerificationEmailAsync(user.Email, user.UserName, user.EmailVerificationCode);


            return new()
            {
                Success = true,
                Message = "Kullanıcı başarıyla oluşturuldu."
            };
        }
        public async Task<BaseResponse> VerifyEmailAsync(VerfifyUserEmailDto request)
        {
            if (string.IsNullOrEmpty(request.Email) || string.IsNullOrEmpty(request.Code))
            {
                throw new Exception("Email ve kod alanları boş olamaz");
            }

            User user = await _repository.AsQueryable().
                FirstOrDefaultAsync(x => x.Email == request.Email
                && x.EmailVerificationCode == request.Code
                && x.EmailVerificationCodeExpiresOn > DateTime.Now);


            if (user is null)
            {
                throw new Exception("Email doğrulama kodu hatalı veya süresi dolmuş");
            }


            user.EmailVerificationCode = null;
            user.EmailVerificationCodeExpiresOn = null;
            user.IsEmailVerified = true;

            await _repository.UpdateAsync(user);



            return new()
            {
                Success = true,
                Message = "Email doğrulandı"
            };
        }
        public async Task<TokenDto> LoginAsync(LoginUserRequest request)
        {
            // Kullanıcı giriş doğrulama işlemi
            await _loginValidator.ValidateAndThrowAsync(request);

            User user = await _repository.AsQueryable()
                 .Include(x => x.UserRoles)
                 .ThenInclude(ur => ur.Role)
                 .Include(x => x.UserPhotos)  // Include UserPhotos here
                 .Where(x => x.Email == request.usernameOrEmail || x.UserName == request.usernameOrEmail)
                 .FirstOrDefaultAsync()
                 ?? throw new Exception("Kullanıcı adı veya şifre hatalı");


            // Şifre kontrolü
            if (!BCrypt.Net.BCrypt.Verify(request.password, user.PasswordHash))
            {
                throw new Exception("Kullanıcı adı veya şifre hatalı");
            }

            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";
            // Token oluşturma için gereksinimleri hazırlıyoruz
            UserTokenDto requierementDto = new()
            {
                Email = user.Email,
                UserName = user.UserName,
                UserId = user.Id,
                UniversityId = user?.UniversityId ?? -1,
                ProfileImage = user.UserPhotos
                        .Where(p => p.isProfilePhoto)
                        .Select(p => $"{baseUrl}/{p.ImagePath}")
                        .FirstOrDefault(),
                UserRoles = user.UserRoles.Select(ur => ur.Role.Name).ToList()
            };



            // Access token ve refresh token oluştur
            TokenDto tokenDto = await _tokenHandler.CreateAccessToken(requierementDto);
            user.RefreshToken = await _tokenHandler.CreateRefreshToken();
            user.RefreshTokenEndDate = tokenDto.Expiration.AddMinutes(15);

            // Kullanıcıyı güncelle
            await _repository.UpdateAsync(user);

            return tokenDto;
        }

        public async Task<TokenDto> RefreshTokenLoginAsync(string refreshToken)
        {
            // Kullanıcıyı refresh token üzerinden bul
            User user = await _repository.AsQueryable()
                .Include(x => x.UserPhotos)
                .Include(x => x.UserRoles)
                .ThenInclude(ur => ur.Role)
                .Where(x => x.RefreshToken == refreshToken)
                .FirstOrDefaultAsync();

            // Kullanıcı bulunamazsa veya refresh token süresi geçmişse hata fırlat
            if (user is null || user.RefreshTokenEndDate < DateTime.UtcNow)
            {
                throw new SecurityTokenException("Refresh token geçersiz veya süresi dolmuş");
            }

            // Yeni access token oluştur
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";
            UserTokenDto requierementDto = new()
            {
                Email = user.Email,
                UserName = user.UserName,
                UserId = user.Id,
                ProfileImage = user.UserPhotos
                    .Where(p => p.isProfilePhoto)
                    .Select(p => $"{baseUrl}/{p.ImagePath}")
                    .FirstOrDefault(),
                UniversityId = user.UniversityId ?? -1,
                UserRoles = user.UserRoles.Select(ur => ur.Role.Name).ToList()
            };

            TokenDto tokenDto = await _tokenHandler.CreateAccessToken(requierementDto);

            // Yeni refresh token oluştur ve kullanıcıyı güncelle
            user.RefreshToken = await _tokenHandler.CreateRefreshToken();
            user.RefreshTokenEndDate = tokenDto.Expiration.AddMinutes(15);
            await _repository.UpdateAsync(user);

            return tokenDto;
        }

        public async Task<BaseResponse> ForgotPasswordAsync(string email)
        {
            User user = await _repository.GetSingleAsync(x => x.Email == email);
            if (user is null)
            {
                throw new Exception("Kullanıcı bulunamadı");
            }

            user.PasswordVerificationToken = GenerateVerificationCode();
            user.PasswordVerificationTokenExpiresOn = DateTime.Now.AddMinutes(15);
            await _repository.UpdateAsync(user);
            await _emailHelper.SendPasswordResetEmailAsync(user.Email, user.UserName, user.PasswordVerificationToken);

            return new()
            {
                Success = true,
                Message = "Şifre sıfırlama maili başarı"
            };
        }

        public async Task<TokenDto> GoogleLoginAsync(string idToken, int accessTokenLifeTime)
        {
            string clientId = _configuration["ExternalLoginSettings:Google:Client_ID"];

            var settings = new GoogleJsonWebSignature.ValidationSettings
            {
                Audience = [clientId]
            };

            var payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);

            User user = await _repository.GetSingleAsync(x => x.Email == payload.Email);

            if (user == null)
            {
                // Kullanıcı veritabanında yoksa ekliyoruz
                user = new User
                {
                    Email = payload.Email,
                    UserName = payload.Name,
                    IsEmailVerified = true
                };
                await _repository.AddAsync(user);
            }

            UserTokenDto userTokenDto = new()
            {
                Email = payload.Email,
                UserName = payload.Name,
                UserId = user.Id,
                UserRoles = user.UserRoles.Select(x => x.Role.Name).ToList(),
            };
            // Token oluşturma
            TokenDto tokenDto = await _tokenHandler.CreateAccessToken(userTokenDto);
            user.RefreshToken = await _tokenHandler.CreateRefreshToken();
            user.RefreshTokenEndDate = tokenDto.Expiration.AddMinutes(15);

            // Kullanıcıyı güncelliyoruz
            await _repository.UpdateAsync(user);

            return tokenDto;
        }


        public Task<BaseResponse> ResetPasswordAsync(string email, string token, string password)
        {

            throw new NotImplementedException();
        }

        private string GenerateVerificationCode()
        {
            byte[] randomBytes = new byte[4]; // 4 byte uzunluğunda bir buffer (32-bit)
            RandomNumberGenerator.Fill(randomBytes);
            int randomNumber = BitConverter.ToInt32(randomBytes, 0) & 0x7FFFFFFF; // Negatif değerlerden kaçınmak için bit maskesi
            return (randomNumber % 900000 + 100000).ToString();
        }

    }
}
