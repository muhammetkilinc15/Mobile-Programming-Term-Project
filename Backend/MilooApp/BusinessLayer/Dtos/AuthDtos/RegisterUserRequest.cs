using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.AuthDtos
{
    public sealed record RegisterUserRequest(
        string UserName,
        string Email,
        string Password,
        string FirstName,
        string LastName,
        int UniversityId
     );
}
