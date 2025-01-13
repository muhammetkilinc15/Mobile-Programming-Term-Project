using AutoMapper;
using BusinessLayer.Abstract;
using BusinessLayer.Dtos.CategoryDtos;
using BusinessLayer.Exceptions;
using BusinessLayer.Extensions;
using BusinessLayer.Parameters;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using EntityLayer.Paging;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace BusinessLayer.Concreate
{
    public class CategoryService : BaseService, ICategoryService
    {
        private readonly ICategoryRepository _repository;
        private readonly IValidator<CreateCategoryDto> _createValidator;
        private readonly IValidator<UpdateCategoryDto> _updateValidator;

        public CategoryService(IMapper mapper, ICategoryRepository repository, IValidator<CreateCategoryDto> createValidator, IValidator<UpdateCategoryDto> updateValidator) : base(mapper)
        {
            _repository = repository;
            _createValidator = createValidator;
            _updateValidator = updateValidator;
        }
        public async Task<BaseResponse> GetCategories(BaseRequest request)
        {
            var query = _repository.AsQueryable().AsNoTracking();
            if (!string.IsNullOrWhiteSpace(request.Search))
            {
                query = query.Where(x => x.Name.Contains(request.Search));
            }
            
            
            var result = await query.GetPageAsync(request.PageNumber, request.PageSize) ?? throw new DbValidationException("Categories not found");
            return new()
            {
                Data = result,
                Success = true
            };
        }
        public async Task<BaseResponse> GetByIdAsync(int id)
        {
            Category category = await _repository.GetByIdAsync(id) ?? throw new DbValidationException("Category not found");
            return new()
            {
                Success = true,
                Data = category,
            };
        }
        public async Task<BaseResponse> GetByNameAsync(string name)
        {
            Category category = await _repository.AsQueryable()
                              .Where(x => x.Name == name)
                              .FirstOrDefaultAsync() ?? throw new DbValidationException("Category not found");

            return new()
            {
                Data = category,
                Success = true
            };
        }
        public async Task<BaseResponse> AddAsync(CreateCategoryDto request)
        {
            await _createValidator.ValidateAndThrowAsync(request);
            Category mappedCategory = _mapper.Map<Category>(request);
            bool result = await _repository.AddAsync(mappedCategory);
            return new()
            {
                Data = result,
                Message = result ? "Category added successfully" : "An error occurred while adding the category",
                Success = result
            };
        }
        public async Task<BaseResponse> DeleteAsync(int id)
        {
            bool result = await _repository.DeleteAsync(id: id);
            return new()
            {
                Message = result ? "Category deleted successfully" : "An error occurred while deleting the category",
                Success = result
            };
        }
        public async Task<BaseResponse> UpdateAsync(UpdateCategoryDto request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);
            Category mappedCategory = _mapper.Map<Category>(request);
            bool result = await _repository.UpdateAsync(mappedCategory);
            return new()
            {
                Data = mappedCategory,
                Message = result ? "Category updated successfully" : "An error occurred while updating the category",
                Success = result
            };
        }

        public async Task<BaseResponse> GetCategoryWithSubCategory(BaseCategoryRequest request)
        {
            var query = await _repository.AsQueryable()
                            .AsNoTracking()
                            .SelectMany(x => x.SubCategories)
                            .Where(x => x.CategoryId == request.CategoryId)
                            .Select(subCategory => new
                            {
                                subCategory.Id,
                                subCategory.Name,          
                            })
                            .GetPageAsync(request.PageNumber, request.PageSize);


            return new()
            {
                Data = query,
                Success = true
            };

        }
    }
}
