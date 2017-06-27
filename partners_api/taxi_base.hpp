#pragma once

#include "partners_api/taxi_provider.hpp"

#include <functional>
#include <string>
#include <vector>

namespace ms
{
class LatLon;
}

namespace taxi
{
/// @products - vector of available products for requested route, cannot be empty.
/// @requestId - identificator which was provided to GetAvailableProducts to identify request.
using ProductsCallback = std::function<void(std::vector<Product> const & products)>;

/// Callback which is called when an errors occurs.
using ErrorProviderCallback = std::function<void(ErrorCode const code)>;

struct RideRequestLinks
{
  std::string m_deepLink;
  std::string m_universalLink;
};

class ApiBase
{
public:
  virtual ~ApiBase() = default;

  /// Requests list of available products. Returns request identificator immediately.
  virtual void GetAvailableProducts(ms::LatLon const & from, ms::LatLon const & to,
                                    ProductsCallback const & successFn,
                                    ErrorProviderCallback const & errorFn) = 0;

  /// Returns link which allows you to launch some taxi app.
  virtual RideRequestLinks GetRideRequestLinks(std::string const & productId,
                                               ms::LatLon const & from,
                                               ms::LatLon const & to) const = 0;

private:
  std::string const m_baseUrl;
};
}  // namespace taxi