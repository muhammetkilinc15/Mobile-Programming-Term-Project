using BusinessLayer.Dtos.ProductDtos;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.ListingValidator
{
    public class CreateListingValidator : AbstractValidator<CreateProductRequest>
    {
        public CreateListingValidator()
        {
            RuleFor(x => x.Title).NotEmpty().WithMessage("Title is required");
            RuleFor(x => x.Description).NotEmpty().WithMessage("Description is required");
            RuleFor(x => x.Price).NotEmpty().WithMessage("Price is required");
            RuleFor(x => x.SubCategoryId).NotEmpty().WithMessage("SubCategoryId is required");
            RuleFor(x => x.PublisherId).NotEmpty().WithMessage("PublisherId is required");
            RuleFor(x => x.Images).NotEmpty().WithMessage("Images are required");
            RuleFor(RuleFor=> RuleFor.Images.Count).GreaterThan(0).WithMessage("At least one image is required");
            RuleFor(x => x.Images).Must(images => images.Count <= 5).WithMessage("Maximum 5 images are allowed");

        }
    }
}
