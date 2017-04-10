#pragma once

#include "partners_api/ads_base.hpp"
#include "partners_api/banner.hpp"

#include <memory>
#include <string>
#include <vector>

namespace feature
{
class TypesHolder;
}

namespace ads
{
class Engine
{
public:
  Engine();

  bool HasBanner(feature::TypesHolder const & types, storage::TCountriesVec const & countryIds) const;
  std::vector<Banner> GetBanners(feature::TypesHolder const & types,
                                 storage::TCountriesVec const & countryIds) const;

private:
  using ContainerPtr = std::unique_ptr<ContainerBase>;

  struct ContainerItem
  {
    ContainerItem(Banner::Type type, ContainerPtr && container)
      : m_type(type), m_container(std::move(container))
    {
    }

    Banner::Type m_type;
    ContainerPtr m_container;
  };

  std::vector<ContainerItem> m_containers;
};
}  // namespace ads