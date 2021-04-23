/*
    Developed by: Michael Snowden
*/

// This file contains your Data Connector logic
section FortifyOnDemand;

BaseUrl = "https://api.ams.fortify.com/swagger/docs/v3";
OAuthBaseUrl = "https://api.ams.fortify.com/oauth";

grant_type = "password";
scope = "api-tenant";

[DataSource.Kind="FortifyOnDemand", Publish="FortifyOnDemand.Publish"]
shared FortifyOnDemand.Contents = () =>
    let
        credential = Extension.CurrentCredential(),
        token = if (credential[AuthenticationKind] = "Key") then credential[Key] else TokenMethod(credential[Username],credential[Password]),
        headers = [ Authorization = "Bearer " & token ],
        navTable = OpenApi.Document(Web.Contents(BaseUrl), [ Headers = headers, ManualCredentials = true, IncludeMoreColumns = true, IncludeExtensions = true ])
    in
        navTable;

// Data Source Kind description
FortifyOnDemand = [
    Authentication = [
        Key = [
            KeyLabel = Extension.LoadString("keyLabel"),
            Label = Extension.LoadString("authKindLabel")
        ],
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("usernameLabel"),
            PasswordLabel= Extension.LoadString("passwordLabel"),
            Label= Extension.LoadString("usernamePasswordLabel")
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
FortifyOnDemand.Publish = [
    Beta = true,
    Category = "Online Services",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = Fortify.Icons,
    SourceTypeImage = Fortify.Icons
];

Fortify.Icons = [
    Icon16 = { Extension.Contents("FortifyOnDemand16.png"), Extension.Contents("FortifyOnDemand20.png"), Extension.Contents("FortifyOnDemand24.png"), Extension.Contents("FortifyOnDemand32.png") },
    Icon32 = { Extension.Contents("FortifyOnDemand32.png"), Extension.Contents("FortifyOnDemand40.png"), Extension.Contents("FortifyOnDemand48.png"), Extension.Contents("FortifyOnDemand64.png") }
];

// Getting Auth Token
TokenMethod = (userName, password) =>
    let
        FormData = 
            "grant_type=" & "password"
            & "&scope=" & "api-tenant" 
            & "&username=" & userName 
            & "&password=" & password
            & "&security_code=",

        Response = Web.Contents(
            OAuthBaseUrl & "/token", 
            [ 
                Content = Text.ToBinary(FormData),
                Headers=[ 
                    #"Content-type" = "application/x-www-form-urlencoded; charset=UTF-8", 
                    #"Accept" = "*/*",
                    #"Authorization" = "" // Need to do this to overwrite the Authorization header that Power BI tries to create.
                ]
            ]
            
        ),
        BearerToken = Json.Document(Response)[access_token]
    in
        BearerToken;