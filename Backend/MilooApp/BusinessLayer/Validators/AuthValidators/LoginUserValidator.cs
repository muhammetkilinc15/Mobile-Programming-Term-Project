using BusinessLayer.Dtos.AuthDtos;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.AuthValidators
{
    public class LoginUserValidator : AbstractValidator<LoginUserRequest>
    {
        public LoginUserValidator()
        {
            RuleFor(x => x.usernameOrEmail).NotEmpty().WithMessage("Kullanıcı adı veya email boş olamaz");
            RuleFor(x => x.password).NotEmpty().WithMessage("Şifre boş olamaz");
        }
    }
}
