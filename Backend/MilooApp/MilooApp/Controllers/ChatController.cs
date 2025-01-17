using BusinessLayer.Dtos.ChatDtos;
using BusinessLayer.Helpers;
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
    public class ChatController : ControllerBase
    {
        private readonly IHubContext<ChatHub> _hubContext;
        private readonly ApplicationDbContext _context;
        public ChatController(IHubContext<ChatHub> hubContext, ApplicationDbContext context)
        {
            _hubContext = hubContext;
            _context = context;
        }


        [HttpGet("users/{userId}")]
        public async Task<IActionResult> GetUsers(int userId)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            // Mesajları çekiyoruz, sadece gerekli ilişkileri dahil ediyoruz
            var messages = await _context.Messages
                .Where(x => x.SenderId == userId || x.ReceiverId == userId)
                .Select(x => new
                {
                    UserId = x.SenderId == userId ? x.ReceiverId : x.SenderId,
                    SenderFullName = x.SenderId == userId ? x.Receiver.FirstName + " " + x.Receiver.LastName : x.Sender.FirstName + " " + x.Sender.LastName,
                    ReceiverProfilePhoto = x.SenderId == userId ? x.Receiver.UserPhotos.FirstOrDefault(p => p.isProfilePhoto).ImagePath : x.Sender.UserPhotos.FirstOrDefault(p => p.isProfilePhoto).ImagePath,
                    LastMessage = new
                    {
                        MessageId = x.Id,
                        Message = x.MessageText, // Mesaj içeriği
                        SendDate = x.SentOn.ToString("yyyy-MM-dd HH:mm:ss"),
                        x.IsRead
                    }
                })
                .ToListAsync();

            // Kullanıcıları grupluyoruz ve son mesajlarını getiriyoruz
            var users = messages
                .GroupBy(x => x.UserId)
                .Select(group => new
                {
                    UserId = group.Key,
                    FullName = group.First().SenderFullName,
                    ProfilePhoto = baseUrl + "/" + group.First().ReceiverProfilePhoto,
                    LastMessage = group
                        .OrderByDescending(m => m.LastMessage.SendDate)
                        .Select(m => new
                        {
                            m.LastMessage.MessageId,
                            m.LastMessage.Message,
                            m.LastMessage.SendDate,
                            m.LastMessage.IsRead
                        })
                        .FirstOrDefault()
                })
                .OrderByDescending(x => x.LastMessage.SendDate)
                .ToList();

            return Ok(users);
        }





        [HttpGet("chats")]
        public async Task<IActionResult> GetChats(int userId, int toUserId, CancellationToken cancellationToken)
        {
            List<Message> chats =
                await _context.Messages
                .Where(p =>
                    p.SenderId == userId && p.ReceiverId == toUserId ||
                    p.ReceiverId == userId && p.SenderId == toUserId)
                .OrderBy(p => p.SentOn)
                .ToListAsync(cancellationToken);

            return Ok(chats);
        }


        [HttpPost("SendMessage")]
        public async Task<IActionResult> SendMessage([FromBody]SendMessageDto message)
        {
            Message chat = new()
            {
                SenderId = message.userId,
                ReceiverId = message.toUserId,
                MessageText = message.message,
                SentOn = DateTime.Now
            };
            await _context.AddAsync(chat);
            await _context.SaveChangesAsync();
            string? connectionId = ChatHub.Users.FirstOrDefault(p => p.Value == chat.ReceiverId).Key;

            if (connectionId == null)
            {
                return Ok("User not active");
            }

            await _hubContext.Clients.Client(connectionId).SendAsync("Messages", chat);
            return Ok(chat);
        }
    }
}
