using BusinessLayer.Abstract;
using BusinessLayer.Abstract.Token;
using BusinessLayer.Concreate;
using BusinessLayer.Concreate.Token;
using BusinessLayer.Helpers.EmailHelper;
using BusinessLayer.Helpers.FileHelper;
using DataAccessLayer;
using DataAccessLayer.Abstract;
using DataAccessLayer.Concreate;
using FluentValidation;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public static class ServiceRegistration
    {

        public static void AddBusinessLayerRegistration(this IServiceCollection services, IConfiguration  configuration)
        {
            // EmailSettings'i yapılandırma
            services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));


            services.AddDataAccesRegistration(); 

            var assembly = Assembly.GetExecutingAssembly();

            services.AddAutoMapper(assembly);
            services.AddValidatorsFromAssembly(assembly);

            HelperRegister(services);
            ServiceRegister(services);
        }
        private static void ServiceRegister(this IServiceCollection services)
        {
            services.AddScoped<ICategoryService, CategoryService>();
            services.AddScoped<ICollageService, UniversityService>();
            services.AddScoped<IProductService, ProductService>();
            services.AddScoped<IAuthService, AuthService>();
            services.AddScoped<IUserService, UserService>();
            services.AddScoped<ITokenHandler, TokenHandler>();
        }

        private static void HelperRegister(this IServiceCollection services)
        {
            services.AddScoped<IFileHelper, FileHelper>();
            services.AddScoped<IEmailHelper, EmailHelper>();

        }
    }
}
