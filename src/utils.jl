# Gregorian calendar-ic globals
const second = 1.0
const minute = 60second
const hour = 60minute
const day = 24hour
const year = 365day
const stellaryear = 23hour + 56minute + 4.098903691
const Ω = 2π/stellaryear

function pressenter()
  println("\nPress enter to continue.")
  chomp(readline())
end

macro zeros(T, dims, vars...)
  expr = Expr(:block)
  append!(expr.args, [:($(esc(var)) = zeros($(esc(T)), $(esc(dims))); ) for var in vars])
  expr
end

macro def(name, definition)
  return quote
      macro $(esc(name))()
          esc($(Expr(:quote, definition)))
      end
  end
end

macro def_solution_fields(T, names...)
  solution_fields = [ :($(name)::$(T)) for name in names ]
  equation_fields = [ :($(name)::Function) for name in names ]
  bc_fields = [ :($(name)::FieldBoundaryConditions) for name in names ]
  nfields = length(solution_fields)
  esc(
    quote
      struct Solution <: AbstractSolution{1,$(T)}
        $(solution_fields...)
      end

      struct Equation <: FieldVector{$(nfields),Function}
        $(equation_fields...)
      end

      struct BoundaryConditions <: FieldVector{$(nfields),FieldBoundaryConditions}
        $(bc_fields...)
      end
    end
  )
end

