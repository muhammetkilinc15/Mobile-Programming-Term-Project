using BusinessLayer.Abstract;
using BusinessLayer.Dtos.ChatDtos;
using BusinessLayer.Helpers;
using BusinessLayer.Parameters;
using DataAccessLayer.Context;
using EntityLayer.Entites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using MilooApp.Hubs;
using System;
using System.Threading;

namespace MilooApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize]
    public class ChatController(IHubContext<ChatHub> hubContext, IChatService chatService) : ControllerBase
    {
        [HttpGet("users/{userId}")]
        public async Task<IActionResult> GetUsers(int userId)
        {
           BaseResponse baseResponse = await chatService.GetChatList(userId);
            if (baseResponse.Success)
            {
                return Ok(baseResponse.Data);
            }

            return BadRequest(baseResponse.Message);
        }


        [HttpGet("chats")]
        public async Task<IActionResult> GetChats(int userId, int toUserId, CancellationToken cancellationToken)
        {
            BaseResponse baseResponse = await chatService.GetChats(userId, toUserId, cancellationToken);
            if (baseResponse.Success)
            {
                return Ok(baseResponse.Data);
            }
            return BadRequest(baseResponse.Message);
        }


        [HttpPost("SendMessage")]
        public async Task<IActionResult> SendMessage([FromBody]SendMessageDto message)
        {
            BaseResponse baseResponse = await chatService.SendMessageAsync(message);

            Message chat = baseResponse.Data as Message;

            string? connectionId = ChatHub.Users.FirstOrDefault(p => p.Value == chat?.ReceiverId).Key;

            if (connectionId == null)
            {
                return Ok("User not active");
            }

            await hubContext.Clients.Client(connectionId).SendAsync("Messages", chat);
            return Ok(chat);
        }
    }
}
