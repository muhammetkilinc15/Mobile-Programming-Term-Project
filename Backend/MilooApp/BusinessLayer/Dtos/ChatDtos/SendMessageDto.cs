using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.ChatDtos
{
    public record SendMessageDto(int userId, int toUserId, string message);
}
