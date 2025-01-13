using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.AuthDtos
{
    public sealed record LoginUserRequest(string usernameOrEmail, string password);
   
}
