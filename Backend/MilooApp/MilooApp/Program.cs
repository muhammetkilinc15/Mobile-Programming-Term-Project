using BusinessLayer;
using BusinessLayer.Helpers.EmailHelper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using NotArkadasimApi.Infsracture.Extensions;
using System.Security.Authentication;
using System.Security;
using System.Security.Claims;
using System.Text;
using System.Globalization;
using MilooApp.Hubs;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddBusinessLayerRegistration(builder.Configuration);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(5105); // 5000 portundan gelen tüm IP'leri dinle
});

// Kültür ayarlarý
var cultureInfo = new CultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = cultureInfo;
CultureInfo.DefaultThreadCurrentUICulture = cultureInfo;

// HTTPS yönlendirme tamamen devre dýþý býrakýldý
// builder.Services.AddHttpsRedirection(options =>
// {
//     options.HttpsPort = null; 
// });


builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer("Bearer", options =>
    {
        options.TokenValidationParameters = new()
        {
            ValidateAudience = true,
            ValidateIssuer = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidAudience = builder.Configuration["Token:Audience"],
            ValidIssuer = builder.Configuration["Token:Issuer"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Token:SecurityKey"])),
            LifetimeValidator = (notBefore, expires, securityToken, validationParameters) => expires != null ? expires > DateTime.UtcNow : false,
            
            
        };
        options.Events = new JwtBearerEvents
        {
            OnChallenge = context =>
            {
                context.HandleResponse();
                throw new UnauthorizedAccessException("Unauthorized access.");
            },
            OnForbidden = context =>
            {
                throw new SecurityException("Forbidden access.");
            },
            OnAuthenticationFailed = context =>
            {
                throw new AuthenticationException("Authentication failed.");
            },
        };
    });

builder.Services.AddControllers();
builder.Services.AddSignalR();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo { Title = "API", Version = "v1" });
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Bearer token. Örnek: 'Bearer {token}'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

builder.Services.AddResponseCompression(opt =>
{
    opt.EnableForHttps = true;
    opt.MimeTypes = new[] { "application/json" };
});



var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.MapHub<ChatHub>("/ChatHub");
app.UseDefaultFiles();
app.UseResponseCompression();
app.UseStaticFiles(); // wwwroot klasöründeki statik dosyalara eriþimi etkinleþtirir


// HTTPS yönlendirme kaldýrýldý
// app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.ConfigureExceptionHandling();

app.MapControllers();

app.Run();
