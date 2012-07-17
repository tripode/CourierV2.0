class CargoManifestDetail < ActiveRecord::Base
  belongs_to :cargo_manifest
  belongs_to :transport_guide
end
