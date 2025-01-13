using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Dtos.ProductDtos;
using BusinessLayer.Parameters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Abstract
{
    public interface IProductService
    {
        Task<BaseResponse> GetUserProducts(UserProductRequest request);
        Task<BaseResponse> GetAllProducts(BaseProductRequestDto request);
        Task<BaseResponse> GetFavoriteProducts(FavoriProductRequest request);
        Task<BaseResponse> AddAsync(CreateProductRequest request);
        Task<BaseResponse> MarkSold(int id);
        Task<BaseResponse> UpdateAsync(UpdateProductDto request);
        Task<BaseResponse> AddFavoriteProduct(MakeFavoriteProductDto request);
        Task<BaseResponse> IncreaseProductView(IncreaseProductView request);
        Task<BaseResponse> DeleteAsync(int id);
        Task<BaseResponse> GetByIdAsync(int id);
        Task<BaseResponse> GetPopularProducts(int top,int universityId, int userId);
    }
}
