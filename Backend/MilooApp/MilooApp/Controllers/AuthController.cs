using BusinessLayer.Abstract;
using BusinessLayer.Dtos.AuthDtos;
using BusinessLayer.Dtos.TokenDtos;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using DataAccessLayer.Context;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody]RegisterUserRequest request)
        {
            BaseResponse response = await _authService.RegisterAsync(request);
            return Ok(response.Message);
        }

        [HttpPost("verify-email")]
        public async Task<IActionResult> VerifyEmail([FromBody] VerfifyUserEmailDto request)
        {
            BaseResponse response = await _authService.VerifyEmailAsync(request);
            if(response.Success)
            {
                return Ok(response.Message);
            }
            return BadRequest(response.Message);
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginUserRequest request)
        {
            TokenDto token = await _authService.LoginAsync(request);
            return Ok(token);
        }
        [HttpPost("refresh-token")]
        public async Task<IActionResult> RefreshTokenLogin([FromBody] RefreshTokenDto request )
        {
            TokenDto token = await _authService.RefreshTokenLoginAsync(request.refreshToken);
            return Ok(token);
        }

        [HttpPost("google-login")]
        public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginDto request)
        {
            TokenDto token = await _authService.GoogleLoginAsync(request.idToken, 15);
            return Ok(token);
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
        {
            BaseResponse response = await _authService.ForgotPasswordAsync(request.Email);
            return Ok(response.Message);
        }




    }
}
