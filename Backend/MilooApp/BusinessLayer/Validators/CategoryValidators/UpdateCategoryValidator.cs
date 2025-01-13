using BusinessLayer.Dtos.CategoryDtos;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.CategoryValidators
{
    public class UpdateCategoryValidator : AbstractValidator<UpdateCategoryDto>
    {
        public UpdateCategoryValidator()
        {

          
            RuleFor(x => x.Id).NotEmpty().WithMessage("Id is not be empty").Must(x => x > 0).WithMessage("Id is not be less than 1");
            RuleFor(x => x.Name).NotEmpty().WithMessage("Name is not be empty");

        }
    }
}
