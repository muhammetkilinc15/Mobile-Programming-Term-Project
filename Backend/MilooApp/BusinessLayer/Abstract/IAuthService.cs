using BusinessLayer.Dtos.AuthDtos;
using BusinessLayer.Dtos.TokenDtos;
using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface IAuthService
    {
        Task<TokenDto> LoginAsync(LoginUserRequest request);
        Task<BaseResponse> RegisterAsync(RegisterUserRequest request);
        Task<BaseResponse> VerifyEmailAsync(VerfifyUserEmailDto request);
        Task<TokenDto> RefreshTokenLoginAsync(string refreshToken);
        Task<BaseResponse> ForgotPasswordAsync(string email);
        Task<BaseResponse> ResetPasswordAsync(string email, string token, string password);
        Task<TokenDto> GoogleLoginAsync(string idToken, int accessTokenLifeTime);
    }
}
