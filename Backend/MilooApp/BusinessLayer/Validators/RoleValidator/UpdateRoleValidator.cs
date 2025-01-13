using BusinessLayer.Dtos.RoleDtos;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.RoleValidator
{
    public class UpdateRoleValidator : AbstractValidator<UpdateRoleDto>
    {
        public UpdateRoleValidator()
        {
            RuleFor(x => x.Id).GreaterThan(0).WithMessage("Id must be greater than 0");
            RuleFor(x => x.Name)
          .NotEmpty().WithMessage("Name cannot be empty")
          .MinimumLength(3).WithMessage("Name must be greater than 3 characters")
          .MaximumLength(50).WithMessage("Name must be less than 50 characters")
          .Matches("^[a-zA-Z]*$").WithMessage("Name must contain only letters");

        }
    }
}
