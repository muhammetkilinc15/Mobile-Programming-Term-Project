using BusinessLayer.Dtos.ProductDtos;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.ListingValidator
{
    public class UpdateProductValidator : AbstractValidator<UpdateProductDto>
    {
        public UpdateProductValidator()
        {
            RuleFor(x => x.Title).NotEmpty().WithMessage("Title is required").ChildRules(x =>
            {
                x.RuleFor(x => x).MaximumLength(50).WithMessage("Title can be maximum 50 characters");
            });
            //RuleFor(x => x.Description).NotEmpty().WithMessage("Description is required").ChildRules(x =>
            //{
            //    x.RuleFor(x => x).MaximumLength(500).WithMessage("Description can be maximum 500 characters");
            //});

        }
    }
}
