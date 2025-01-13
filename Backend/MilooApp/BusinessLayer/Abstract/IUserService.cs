using BusinessLayer.Dtos.UserDtos;
using BusinessLayer.Parameters;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface IUserService
    {

        Task<BaseResponse> GetUserRoles(int userId);
        Task<BaseResponse> GetUsers();
        Task<BaseResponse> GetUserById(int userId);
        Task<BaseResponse> GetUserInfoWithProductById(string username);
        Task<BaseResponse> DeleteUser(int userId);
        Task<BaseResponse> GetPopularUsers(int top,int userId);
        Task<BaseResponse> UpdateUserAsync(UpdateUserDto request);

        Task UpdateRefreshTokenAsync(string refreshToken, User user, DateTime accessTokenDate);
        Task UpdatePasswordAsync(User user, string password);
    }
}
