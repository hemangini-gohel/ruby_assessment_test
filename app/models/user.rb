class User < ApplicationRecord
  enum kind: { student: 0, teacher: 1, student_teacher: 2 }
  has_many :enrollments
  has_many :programs, through: :enrollments
  has_many :favorite_enrollments, -> { where(favorite: true) }, class_name: 'Enrollment'
  has_many :favorite_teachers, through: :favorite_enrollments, source: :teacher, class_name: 'User'
  has_many :classmate_enrollments, through: :programs, source: :enrollments
  has_many :classmates, ->{ distinct }, through: :classmate_enrollments, source: :user

  before_update :check_kind_errors

  private

  def check_kind_errors
    if kind_changed? && student? && teaching_programs.exists?
      errors.add(:kind, "can not be student because is teaching in at least one program")
      throw :abort
    elsif kind_changed? && teacher? && studying_programs.exists?
      errors.add(:kind, "can not be teacher because is studying in at least one program")
      throw :abort
    end
  end

  def teaching_programs
    Program.joins(:enrollments).where(enrollments: { teacher: self })
  end

  def studying_programs
    Program.joins(:enrollments).where(enrollments: { user: self })
  end
end
