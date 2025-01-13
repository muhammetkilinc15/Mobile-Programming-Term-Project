using BusinessLayer.Dtos.TokenDtos;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract.Token
{
    public interface ITokenHandler
    {
        Task<TokenDto> CreateAccessToken(UserTokenDto user);
        Task<string> CreateRefreshToken();
    }
}
