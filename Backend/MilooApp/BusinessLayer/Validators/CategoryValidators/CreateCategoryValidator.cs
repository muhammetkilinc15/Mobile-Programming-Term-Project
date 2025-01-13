using BusinessLayer.Dtos.CategoryDtos;
using EntityLayer.Entites;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.CategoryValidators
{
    public class CreateCategoryValidator : AbstractValidator<CreateCategoryDto>
    {
        public CreateCategoryValidator() 
        {
            RuleFor(x => x.Name).NotEmpty().WithMessage("Name is required");
            RuleFor(x => x.Name).MinimumLength(3).WithMessage("Name must be at least 3 characters");    
            RuleFor(x => x.Name).MaximumLength(50).WithMessage("Name must be less than 50 characters");
        }
    }
}
