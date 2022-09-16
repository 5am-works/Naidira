using System.Text.Json.Serialization;

namespace NaidiraClient.Data;

public class Word {
   [JsonPropertyName("type")] public string Type { get; set; } = "";
   [JsonPropertyName("spelling")] public string Spelling { get; set; } = "";
   [JsonPropertyName("simple_meaning")] public string SimpleMeaning { get; set; } = "";
   [JsonPropertyName("modifiable_types")] public List<string>? ModifiableTypes { get; set; }
   [JsonPropertyName("attachment_types")] public List<string>? AttachmentTypes { get; set; }
   [JsonPropertyName("attachment_notes")] public List<string?>? AttachmentNotes { get; set; }
   [JsonPropertyName("formatted_meaning")] public string? FormattedMeaning { get; set; }
}