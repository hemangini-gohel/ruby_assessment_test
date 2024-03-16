module UsersHelper
  def favorite_teachers(user)
    user.favorite_teachers.pluck(:name).join(', ')
  end

  def classmates(user)
    user.classmates.where.not(id: user.id).pluck(:name).join(', ') 
  end
end
