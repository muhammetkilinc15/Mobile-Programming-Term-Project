using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Parameters;
using EntityLayer.Entites;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface ICollageService 
    {
        Task<BaseResponse> GetPagedResponseAsync(BaseRequest request);
        Task<BaseResponse> AddAsync(CreateCollageDto request);
        Task<BaseResponse> UpdateAsync(UpdateCollageDto request);
        Task<BaseResponse> DeleteAsync(int id);
        Task<BaseResponse> GetByIdAsync(int id);
        Task<BaseResponse> GetByNameAsync(string name);

    }
}
