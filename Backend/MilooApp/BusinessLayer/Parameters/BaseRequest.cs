using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Parameters
{
    public record BaseRequest
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 9;
        public string OrderBy { get; set; } = "Id"; 
        public string Search { get; set; } = string.Empty; 
    }
}
