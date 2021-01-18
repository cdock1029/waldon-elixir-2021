# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Waldon.Repo.insert!(%Waldon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Timex, only: [to_datetime: 2]

alias Waldon.Repo
alias Waldon.Properties.{Property, Unit}
alias Waldon.Tenants.Tenant
alias Waldon.Leases.Lease

Repo.delete_all(Property)
Repo.delete_all(Unit)
Repo.delete_all(Tenant)
Repo.delete_all(Lease)

acme =
  Repo.insert!(%Property{
    name: "ACME",
    units: [
      %Unit{
        name: "101",
        leases: [
          %Lease{
            # to_datetime("Etc/UTC"),
            start_time: to_datetime({2020, 2, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
            end_time: to_datetime({2021, 2, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
            rent: Decimal.new(450),
            tenants: [
              %Tenant{first_name: "Mona", last_name: "Dockry"},
              %Tenant{first_name: "Soairse", last_name: "Dockry"}
            ]
          },
          %Lease{
            start_time: to_datetime({2019, 1, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
            end_time: to_datetime({2020, 1, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
            rent: Decimal.new(400),
            tenants: [
              %Tenant{
                first_name: "Mitchell",
                middle_name: "Herbert",
                last_name: "Raccoon",
                email: "mitchell@aol.com"
              }
            ]
          }
        ]
      },
      %Unit{name: "102"},
      %Unit{name: "103"},
      %Unit{name: "201"},
      %Unit{name: "202"},
      %Unit{name: "203"}
    ]
  })

[acme_101 | [acme_102 | _rest]] = acme.units
[lease1 | [lease2 | _rest]] = acme_101 |> Map.get(:leases)
[mona | [sersh | _rest]] = lease1 |> Map.get(:tenants)
[mitchell] = lease2 |> Map.get(:tenants)

Repo.insert!(%Property{
  name: "WVV",
  units: [
    %Unit{name: "11-101"},
    %Unit{
      name: "11-102",
      leases: [
        %Lease{
          # to_datetime("Etc/UTC"),
          start_time: to_datetime({2020, 10, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
          end_time: to_datetime({2021, 10, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
          rent: Decimal.new(990),
          deposit: Decimal.new(990),
          tenants: [
            %Tenant{
              first_name: "Huckleberry",
              last_name: "Oráiste"
            }
          ]
        }
      ]
    },
    %Unit{name: "11-301"},
    %Unit{name: "11-103"},
    %Unit{name: "11-302"}
  ]
})

Repo.insert!(%Property{
  name: "Columbiana",
  units: [
    %Unit{name: "31-101"},
    %Unit{
      name: "31-102",
      leases: [
        %Lease{
          # to_datetime("Etc/UTC"),
          start_time: to_datetime({2021, 1, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
          end_time: to_datetime({2022, 1, 1}, "America/New_York") |> to_datetime("Etc/UTC"),
          rent: Decimal.new(550),
          deposit: Decimal.new(550),
          tenants: [
            mitchell
          ]
        }
      ]
    },
    %Unit{name: "35-308"},
    %Unit{name: "35-208"},
    %Unit{name: "31-103"}
  ]
})

# {:ok, wvv2} =
#   Repo.insert!(%Property{
#     name: "WVV 2"
#   })

# Repo.insert!(%Property{
#   name: "Columbiana Manor"
# })

# Repo.insert!(%Property{
#   name: "Westchester Executive"
# })

# Repo.insert!(%Property{
#   name: "Westchester Commons"
# })
