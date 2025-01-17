using BusinessLayer.Abstract;
using BusinessLayer.Dtos.UserDtos;
using BusinessLayer.Dtos.UserDtos.Request;
using BusinessLayer.Parameters;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController(IUserService userService) : ControllerBase
    {
        private readonly IUserService _userService = userService;

        [HttpGet("user-info/{userId}")]
        public async Task<IActionResult> GetUserInfo(int userId)
        {
            BaseResponse response = await _userService.GetUserById(userId);
            if (!response.Success)
            {
                return BadRequest(response);
            }
            return Ok(response.Data);
        }
       


        [HttpPut("update")]
        public async Task<IActionResult> UpdateUser([FromForm] UpdateUserDto request)
        {
            
            BaseResponse response = await _userService.UpdateUserAsync(request);
            if (response.Success)
            {
                return Ok(response.Data);
            }
            return BadRequest(response.Message);
        }


        [HttpGet("popular-users")]
        public async Task<IActionResult> GetPopularUsers([FromQuery]PopularUserRequest request)
        {
            BaseResponse response = await _userService.GetPopularUsers(request);

            if (!response.Success)
            {
                return BadRequest(response);
            }
            return Ok(response.Data);
        }
        [HttpGet("get-users")]
        public async Task<IActionResult> GetUsers([FromQuery]UsersRequest request)
        {
            BaseResponse response = await _userService.GetUsers(request);
            if (!response.Success)
            {
                return BadRequest(response);
            }
            return Ok(response.Data);
        }


        [HttpGet("user-info-with-product/{username}")]
        public async Task<IActionResult> GetUserInfoWithProductById(string username)
        {
            BaseResponse response = await _userService.GetUserInfoWithProductById(username: username);
            if (!response.Success)
            {
                return BadRequest(response);
            }
            return Ok(response.Data);
        }
    }
}
