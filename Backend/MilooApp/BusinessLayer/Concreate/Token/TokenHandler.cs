using BusinessLayer.Abstract.Token;
using BusinessLayer.Dtos.TokenDtos;
using EntityLayer.Entites;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Concreate.Token
{
    public class TokenHandler(IConfiguration configuration) : ITokenHandler
    {
        private readonly IConfiguration _configuration = configuration;
        public async Task<TokenDto> CreateAccessToken(UserTokenDto user)
        {
            TokenDto token = new(); 
            SymmetricSecurityKey key = new(Encoding.UTF8.GetBytes(_configuration["Token:SecurityKey"])); 
            SigningCredentials credentials = new(key, SecurityAlgorithms.HmacSha256);
            token.Expiration = DateTime.Now.AddDays(30);

            List<Claim> claims = new List<Claim>
            {
                new Claim("userId", user.UserId.ToString()),
                new Claim("username", user.UserName),
                new Claim("email", user.Email),
                new Claim("universityId", user.UniversityId.ToString()),
                new Claim("profileImage", user.ProfileImage),
                new Claim("roles", string.Join(",",user.UserRoles))
            };


            JwtSecurityToken securityToken = new(
                issuer: _configuration["Token:Issuer"],
                audience: _configuration["Token:Audience"],
                expires: token.Expiration,
                signingCredentials: credentials,
                claims: claims
            );

            JwtSecurityTokenHandler tokenHandler = new();
            token.AccessToken = tokenHandler.WriteToken(securityToken);
            token.RefreshToken = await CreateRefreshToken();
            return token;
        }
        public Task<string> CreateRefreshToken()
        {
            byte[] number = new byte[32];
            using var rng = System.Security.Cryptography.RandomNumberGenerator.Create();
            rng.GetBytes(number);
            return Task.FromResult(Convert.ToBase64String(number));
        }
    }
}
