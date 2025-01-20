using BusinessLayer.Abstract;
using BusinessLayer.Dtos.ChatDtos;
using BusinessLayer.Helpers;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Concreate
{
    public class ChatService : IChatService
    {
        private readonly IMessageRepository _messageRepository;

        public ChatService(IMessageRepository messageRepository)
        {
            _messageRepository = messageRepository;
        }

        public async Task<BaseResponse> GetChatList(int userId)
        {
            string ipAddress = IPHelper.GetIpAdress();
            string baseUrl = $"http://{ipAddress}:5105";

            var messages = await _messageRepository.AsQueryable()
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

            // Başarılı yanıt dön
            return new BaseResponse
            {
                Data = users,
                Message = "Chat list listed successfully",
                Success = true
            };
        }

        public async Task<BaseResponse> GetChats(int userId, int toUserId, CancellationToken cancellationToken)
        {
            List<Message> chats =
                await _messageRepository.AsQueryable()
                .Where(p =>
                    p.SenderId == userId && p.ReceiverId == toUserId ||
                    p.ReceiverId == userId && p.SenderId == toUserId)
                .OrderBy(p => p.SentOn)
                .ToListAsync(cancellationToken);

            return new()
            {
                Data = chats,
                Message = "Chats listed successfully",
                Success = true
            };
        }

        public async Task<BaseResponse> SendMessageAsync(SendMessageDto message)
        {
            Message chat = new()
            {
                SenderId = message.userId,
                ReceiverId = message.toUserId,
                MessageText = message.message,
                SentOn = DateTime.Now
            };
           
            await _messageRepository.AddAsync(chat);
                  
          return new ()
          {
              Data = chat,
              Message = "Message sent successfully",
              Success = true
          };
        }
    }
}
