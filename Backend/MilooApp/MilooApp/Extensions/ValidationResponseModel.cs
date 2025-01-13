using System.Text.Json.Serialization;

namespace MilooApp.Extensions
{
    public class ValidationResponseModel(IEnumerable<string> Errors)
    {
        public IEnumerable<string> Errors { get; set; } = Errors;



        public ValidationResponseModel(string errorMessage) : this([errorMessage])
        {

        }

        [JsonIgnore]
        public string FlattenErrors => Errors != null
            ? string.Join(Environment.NewLine, Errors)
            : string.Empty;

    }
}
