class Program < ApplicationRecord
  has_many :enrollments
  has_many :students, -> { distinct }, through: :enrollments, source: :student
  has_many :teachers, -> { distinct }, through: :enrollments, source: :teacher
end
