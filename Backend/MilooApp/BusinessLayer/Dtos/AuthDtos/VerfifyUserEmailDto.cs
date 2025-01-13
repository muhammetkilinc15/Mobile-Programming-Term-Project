using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.AuthDtos
{
    public sealed record VerfifyUserEmailDto
    {
        public string Email { get; set; }
        public string Code { get; set; }
    }
}
