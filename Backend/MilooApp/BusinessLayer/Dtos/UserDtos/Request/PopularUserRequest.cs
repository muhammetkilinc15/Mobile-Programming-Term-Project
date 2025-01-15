using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.UserDtos.Request
{
    public class PopularUserRequest
    {
        public int UserId { get; set; }
        public int Top { get; set; } = 5;

    }
}
