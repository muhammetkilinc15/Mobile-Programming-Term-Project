using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Parameters;
using EntityLayer.Entites;
using EntityLayer.Paging;

namespace BusinessLayer.Abstract
{
    public interface ICategoryService 
    {
        Task<BaseResponse> GetCategories(BaseRequest request);
        Task<BaseResponse> GetCategoryWithSubCategory(BaseCategoryRequest request);
        Task<BaseResponse> AddAsync(CreateCategoryDto request);
        Task<BaseResponse> UpdateAsync(UpdateCategoryDto request);
        Task<BaseResponse> DeleteAsync(int id);
        Task<BaseResponse> GetByIdAsync(int id);
        Task<BaseResponse> GetByNameAsync(string name);

    }
}
