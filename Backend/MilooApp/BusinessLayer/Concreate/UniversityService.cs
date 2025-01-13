using AutoMapper;
using BusinessLayer.Abstract;
using BusinessLayer.Dtos.CollageDtos;
using BusinessLayer.Exceptions;
using BusinessLayer.Extensions;
using BusinessLayer.Parameters;
using BusinessLayer.Validators.CategoryValidators;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace BusinessLayer.Concreate
{
    public class UniversityService : BaseService, ICollageService
    {
        private readonly ICollageRepository _repository;
        private readonly IValidator<CreateCollageDto> _createValidator;
        private readonly IValidator<UpdateCollageDto> _updateValidator;

        public UniversityService(IMapper mapper, ICollageRepository repository, IValidator<UpdateCollageDto> updateValidator, IValidator<CreateCollageDto> createValidator) : base(mapper)
        {
            _repository = repository;
            _updateValidator = updateValidator;
            _createValidator = createValidator;
        }

        public async Task<BaseResponse> AddAsync(CreateCollageDto request)
        {
            await _createValidator.ValidateAndThrowAsync(request);
            University collage = _mapper.Map<University>(request);
            bool result = await _repository.AddAsync(collage);
            return new BaseResponse
            {
                Success = result,
                Message = result ? "Collage added successfully" : "Collage could not be added"
            };
        }

        public async Task<BaseResponse> DeleteAsync(int id)
        {
            bool result = await _repository.DeleteAsync(id);
            return new()
            {
                Success = result,
                Message = result ? "Collage deleted successfully" : "Collage could not be deleted"
            };
        }

        public async Task<BaseResponse> GetByIdAsync(int id)
        {
            University collage = await _repository.GetByIdAsync(id) ?? throw new DbValidationException("Collage not found");
            return new()
            {
                Success = true,
                Data = collage
            };
        }

        public async Task<BaseResponse> GetByNameAsync(string name)
        {
            var collage = await _repository.AsQueryable().FirstOrDefaultAsync(x => x.Name == name) 
                ?? throw new DbValidationException("Collage not found");
            return new()
            {
                Success = true,
                Data = collage
            };
        }

        public async Task<BaseResponse> GetPagedResponseAsync(BaseRequest request)
        {
            var query = _repository.AsQueryable().AsNoTracking();

            if (!string.IsNullOrEmpty(request.Search))
            {
                query = query.Where(x => x.Name.Contains(request.Search));
            }
            var result = await query
                    .Select(x => new { x.Id, x.Name })
                    .GetPageAsync(request.PageNumber, request.PageSize)
                    ?? throw new DbValidationException("Collages not found");

            return new()
            {
                Data = result,
                Success = true
            };


        }

        public async Task<BaseResponse> UpdateAsync(UpdateCollageDto request)
        {
            await _updateValidator.ValidateAndThrowAsync(request);
            University mappedCollage = _mapper.Map<University>(request);
            bool result = await _repository.UpdateAsync(mappedCollage);
            return new BaseResponse
            {
                Success = result,
                Message = result ? "Collage updated successfully" : "Collage could not be updated"
            };
        }
    }
}
