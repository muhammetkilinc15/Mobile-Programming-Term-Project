using BusinessLayer.Abstract;
using BusinessLayer.Dtos.UserDtos;
using BusinessLayer.Helpers;
using BusinessLayer.Helpers.FileHelper;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Concreate
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _repository;
        private readonly IFileHelper _fileHelper;

        public UserService(IUserRepository repository, IFileHelper fileHelper)
        {
            _repository = repository;
            _fileHelper = fileHelper;
        }

        public async Task<BaseResponse> DeleteUser(int userId)
        {
            bool result = await _repository.DeleteAsync(userId);
            return new()
            {
              Success = result,
              Message = result ? "User Deleted Successfully" : "User can not deleted"
            };
        }

        public async Task<BaseResponse> GetPopularUsers(int top, int userId)
        {
            // IP adresini alıyoruz
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            // Kullanıcının üniversite ID'sini alıyoruz
            var user = await _repository
                .AsQueryable()
                .AsNoTracking()
                .Where(x => x.Id == userId)
                .Select(x => new { x.UniversityId })
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return new BaseResponse
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            int? universityId = user.UniversityId;


            List<PopularUserDto> popularUsers = await _repository
                .AsQueryable()
                .AsNoTracking()
                .Where(x => x.UniversityId == universityId && x.Id != userId) // Üniversiteye göre filtreliyoruz
                .OrderByDescending(x => x.Id)
                .Take(top)
                .Select(x => new PopularUserDto
                {
                    // Profil fotoğrafı URL'sini oluşturuyoruz
                    ProfileImageUrl = x.UserPhotos
                        .Where(p => p.isProfilePhoto)
                        .Select(p => $"{baseUrl}/{p.ImagePath}") // Tam URL'yi oluştur
                        .FirstOrDefault() ?? $"{baseUrl}/default-profile.png", // Varsayılan profil resmi
                    UserName = x.UserName
                })
                .ToListAsync();

            return new BaseResponse
            {
                Success = true,
                Data = popularUsers
            };
        }

        public async Task<BaseResponse> GetUserById(int userId)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var user = await _repository.AsQueryable()
                .Where(x => x.Id == userId)
                .Select(x => new
                {
                    x.Id,
                    x.FirstName,
                    x.LastName,
                    x.UserName,
                    UniversityName = x.University.Name,
                    ProfileImageUrl = x.UserPhotos
                        .Where(p => p.isProfilePhoto)
                        .Select(p => $"{baseUrl}/{p.ImagePath}")
                        .FirstOrDefault() ?? $"{baseUrl}/default-profile.png"
                })
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return new BaseResponse
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            return new BaseResponse
            {
                Success = true,
                Data = user
            };
        }

        public async Task<BaseResponse> GetUserInfoWithProductById(string username)
        {

            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var values = await _repository.AsQueryable()
              .AsNoTracking()
              .Where(x => x.UserName == username)
              .Select(x => new
              {
                  profilPhoto = x.UserPhotos.Where(p => p.isProfilePhoto).Select(p => $"{baseUrl}/{p.ImagePath}").FirstOrDefault() ?? $"{baseUrl}/default-profile.png",
                  fullName = x.FirstName + " " + x.LastName,
                  universty = x.University.Name,
                  soldProduct = x.Products.Where(p => p.isSold).Count(),
                  posts = x.Products.Count(),
                  products = x.Products.Select(p => new
                  {
                      p.Id,
                      p.Title,
                      p.Price,
                      p.isSold,
                      images = p.Images.Select(pp => $"{baseUrl}/{pp.ImagePath}").ToList()
                  })



              })
              .FirstOrDefaultAsync();

            return new()
            {
                Success = true,
                Data = values
            };
        }
        public Task<BaseResponse> GetUserRoles(int userId)
        {
            throw new NotImplementedException();
        }

        public async Task<BaseResponse> GetUsers()
        {
            var resul = await _repository.GetAllAsync();
            return new()
            {
                Success = true,
                Data = resul
            };
        }

        public Task UpdatePasswordAsync(User user, string password)
        {
            throw new NotImplementedException();
        }

        public async Task UpdateRefreshTokenAsync(string refreshToken, User user, DateTime accessTokenDate)
        {
            if (user is not null)
            {
                user.RefreshToken = refreshToken;
                user.RefreshTokenEndDate = accessTokenDate.AddMinutes(15);
                await _repository.UpdateAsync(user);
            }
            else
            {
                throw new Exception("User not found");
            }
        }

        public async Task<BaseResponse> UpdateUserAsync(UpdateUserDto request)
        {
            // Profil fotoğrafını kaydet
            string filePath = await _fileHelper.SaveUserPhotoAsync(request.ProfileImage, request.UserId);

            // Kullanıcı bilgilerini güncelle
            var userUpdateResult = await _repository.AsQueryable()
                .Where(x => x.Id == request.UserId)
                .ExecuteUpdateAsync(x => x
                    .SetProperty(u => u.UserName, request.UserName)
                    .SetProperty(u => u.FirstName, request.FirstName)
                    .SetProperty(u => u.LastName, request.LastName)
                    .SetProperty(u => u.UniversityId, request.UniversityId)
                );

            // Profil fotoğrafını güncelle veya ekle
            var profilePhotoResult = await _repository.AsQueryable()
                .Where(x => x.Id == request.UserId)
                .SelectMany(x => x.UserPhotos)
                .Where(p => p.isProfilePhoto)
                .ExecuteUpdateAsync(p => p.SetProperty(p => p.ImagePath, filePath));

            if (profilePhotoResult == 0)
            {
                var userPhoto = new UserPhoto
                {
                    UserId = request.UserId,
                    ImagePath = filePath,
                    isProfilePhoto = true
                };

                var user = await _repository.AsQueryable()
                    .Where(x => x.Id == request.UserId)
                    .FirstOrDefaultAsync();

                if (user != null)
                {
                    user.UserPhotos.Add(userPhoto);
                    await _repository.UpdateAsync(user);
                }
            }
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            return new BaseResponse
            {
                Success = userUpdateResult > 0,
                Message = userUpdateResult > 0 ? "User updated successfully" : "User could not be updated",
                Data = new
                {
                    ProfileImageUrl = $"{baseUrl}/{filePath}"
                }

            };
        }

    }
}
