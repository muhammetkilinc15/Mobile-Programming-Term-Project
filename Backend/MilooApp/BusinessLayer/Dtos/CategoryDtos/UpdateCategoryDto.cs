using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Dtos.CategoryDtos
{
    public sealed record UpdateCategoryDto(int Id, string Name);
}
