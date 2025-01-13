using EntityLayer.Entites;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Helpers.FileHelper
{
    public interface IFileHelper
    {
        Task<string> SaveUserPhotoAsync(IFormFile file, int userId);
        Task<List<string>> SaveUserProductsAsync(List<IFormFile> images, int userId);

    }
}
