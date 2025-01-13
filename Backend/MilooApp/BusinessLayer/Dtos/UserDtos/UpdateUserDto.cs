using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.UserDtos
{
    public class UpdateUserDto
    {
        public int UserId { get; set; }
        public IFormFile ProfileImage { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int UniversityId { get; set; }

    }
}
