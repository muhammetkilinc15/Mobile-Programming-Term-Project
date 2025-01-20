using BusinessLayer;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using System.Globalization;
using MilooApp.Hubs;
using NotArkadasimApi.Infsracture.Extensions.NotArkadasimApi.Infsracture.Extensions;
using Microsoft.AspNetCore.Diagnostics;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddBusinessLayerRegistration(builder.Configuration);


// Cors ayarlarý
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
    options.ListenAnyIP(5105); // 5105 portunu dinle
});

// Kültür ayarlarý
var cultureInfo = new CultureInfo("en-US");
CultureInfo.DefaultThreadCurrentCulture = cultureInfo;
CultureInfo.DefaultThreadCurrentUICulture = cultureInfo;


// JWT token doðrulama ayarlarý
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer("Bearer", options =>
    {
        // Token doðrulama ayarlarýný yapýlandýr
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
        // Middleware davranýþlarýný özelleþtiriyoruz
        options.Events = new JwtBearerEvents
        {
            OnChallenge = async context =>
            {
                // Varsayýlan yanýtý engelle
                context.HandleResponse();

                // Kendi hata mesajýný dön
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                context.Response.ContentType = "application/json";

                await context.Response.WriteAsJsonAsync(new
                {
                    error = "Unauthorized",
                    message = "Token is missing or invalid."
                });
            },
            
            OnAuthenticationFailed = async context =>
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                context.Response.ContentType = "application/json";

                await context.Response.WriteAsJsonAsync(new
                {
                    error = "Authentication Failed",
                    message = context.Exception?.Message
                });
            },
            OnForbidden = async context =>
            {
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                context.Response.ContentType = "application/json";
                await context.Response.WriteAsJsonAsync(new
                {
                    error = "Forbidden",
                    message = "You are not authorized to access this resource."
                });
            }
        };
    });



builder.Services.AddControllers();


// SignalR
builder.Services.AddSignalR();

// Swagger belgeleme
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


// Response compression
builder.Services.AddResponseCompression(opt =>
{
    opt.EnableForHttps = true;
    opt.MimeTypes = ["application/json"];
});


// Register the CustomExceptionHandler
builder.Services.AddSingleton<IExceptionHandler, CustomExceptionHandler>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// CORS middleware
app.UseCors("AllowAll");

// SignalR 
app.MapHub<ChatHub>("/ChatHub");


// Response compression middleware
app.UseResponseCompression();


app.UseStaticFiles();


// Authentication middleware
app.UseAuthentication();

// Authorization middleware
app.UseAuthorization();

// Exception handling middleware
app.UseExceptionHandler(appBuilder =>
{
    appBuilder.Run(async context =>
    {
        var exceptionHandler = context.RequestServices.GetRequiredService<IExceptionHandler>();
        var exceptionFeature = context.Features.Get<IExceptionHandlerFeature>();
        if (exceptionFeature?.Error != null)
        {
            await exceptionHandler.TryHandleAsync(context, exceptionFeature.Error, CancellationToken.None);
        }
    });
});

app.MapControllers();

app.Run();
