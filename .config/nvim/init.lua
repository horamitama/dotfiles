local user = os.getenv("USER")

if user == "horamitama" then
  require("pawpunch.lazy")
elseif user == "s-nakaue" then
  require("gc.lazy")
else
  print("user not found.")
  return
end
