local ApplicationCommands = {}

ApplicationCommands.Type = {}
ApplicationCommands.Type.Ping	                             = 1
ApplicationCommands.Type.ApplicationCommand	                 = 2
ApplicationCommands.Type.MessageComponent	                 = 3
ApplicationCommands.Type.ApplicationCommandAutocomplete	     = 4
ApplicationCommands.Type.ModalSubmit	                     = 5

ApplicationCommands.Option = {}
ApplicationCommands.Option.SubCommand =             1
ApplicationCommands.Option.SubCommandGroup =        2	
ApplicationCommands.Option.String =                 3	
ApplicationCommands.Option.Integer =                4
ApplicationCommands.Option.Boolean =                5	
ApplicationCommands.Option.User =                   6	
ApplicationCommands.Option.Channel =                7
ApplicationCommands.Option.Role =                   8	
ApplicationCommands.Option.Mentionable =            9
ApplicationCommands.Option.Number =                 10
ApplicationCommands.Option.Attachment =             11

return ApplicationCommands