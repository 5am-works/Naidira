using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using NaidiraClient;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");
builder.Services.AddHttpClient("APIClient", client => client.BaseAddress = builder.HostEnvironment.IsDevelopment() ?
   new Uri("http://localhost:7071/") : new Uri("https://naidira-api.azurewebsites.net"));
builder.Services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("APIClient"));

await builder.Build().RunAsync();