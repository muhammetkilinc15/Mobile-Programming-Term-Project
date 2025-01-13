using EntityLayer.Entites.Base;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EntityLayer.Entites
{
    public class User :  BaseEntity
    {
        public User()
        {
            UserPhotos = new List<UserPhoto>();
            UserFavoriteProducts = new List<UserFavoriteProducts>();
        }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PasswordHash { get; set; }
        public bool IsEmailVerified { get; set; }
        public string? RefreshToken { get; set; }
        public DateTime? RefreshTokenEndDate { get; set; }



        // Collage relationship with User entity
        public int? UniversityId { get; set; }
        [JsonIgnore]
        public  University University { get; set; }  
     



        // Email verification token and its expiry date
        public string? EmailVerificationCode { get; set; }
        public DateTime? EmailVerificationCodeExpiresOn { get; set; }

        // Password reset token and its expiry date
        public string? PasswordVerificationToken { get; set; }
        public DateTime? PasswordVerificationTokenExpiresOn { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }


        /// <summary>
        ///         Navigation property
        /// </summary>
        [JsonIgnore]
        public ICollection<UserPhoto> UserPhotos { get; set; } // 1 to many relationship with UserPhoto entity
        [JsonIgnore]
        public ICollection<Product> Products { get; set; } // 1 to many relationship with Listing entity
        [JsonIgnore]
        public ICollection<Message> SentMessages { get; set; } // 1 to many relationship with Message entity
        [JsonIgnore]
        public ICollection<Message> ReceivedMessages { get; set; } // 1 to many relationship with Message entity
        [JsonIgnore]
        public ICollection<UserRole> UserRoles { get; set; } // 1 to many relationship with UserRole entity
        [JsonIgnore]
        public ICollection<UserFavoriteProducts> UserFavoriteProducts { get; set; } // 1 to many relationship with UserFavoriteProducts entity


    }
}
