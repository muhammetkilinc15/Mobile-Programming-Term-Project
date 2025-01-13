using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.TokenDtos
{
    public class UserTokenDto
    {
        public int UserId { get; set; }
        public string Email { get; set; }
        public int UniversityId { get; set; }
        public string UserName { get; set; }
        public String ProfileImage { get; set; }
        public List<string> UserRoles { get; set; }

    }
}
