using BusinessLayer.Dtos.ChatDtos;
using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface IChatService
    {
        Task<BaseResponse> GetChatList(int userId);
        Task<BaseResponse> GetChats(int userId, int toUserId, CancellationToken cancellationToken);
        Task<BaseResponse> SendMessageAsync(SendMessageDto message);
    }
}
