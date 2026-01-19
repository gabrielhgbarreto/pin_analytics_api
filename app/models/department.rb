class Department < ApplicationRecord
  has_ancestry

  has_many :employees, dependent: :restrict_with_error

  validates :name, presence: true

  HIERARCHY_LEVELS = {
    "n0_empresa"     => "company",
    "n1_diretoria"   => "directorate",
    "n2_gerencia"    => "management",
    "n3_coordenacao" => "coordination",
    "n4_area"        => "area"
  }
end
