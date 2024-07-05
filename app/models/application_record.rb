# ApplicationRecord serves as the primary abstract class for all models in the Rails application.
# It inherits from ActiveRecord::Base and sets itself as the primary abstract class.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
