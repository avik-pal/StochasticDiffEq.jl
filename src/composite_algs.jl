mutable struct AutoSwitchCache{nAlg,sAlg,tolType,T}
  count::Int
  nonstiffalg::nAlg
  stiffalg::sAlg
  is_stiffalg::Bool
  maxstiffstep::Int
  maxnonstiffstep::Int
  nonstifftol::tolType
  stifftol::tolType
  dtfac::T
  stiffalgfirst::Bool
end

struct AutoSwitch{nAlg,sAlg,tolType,T}
  nonstiffalg::nAlg
  stiffalg::sAlg
  maxstiffstep::Int
  maxnonstiffstep::Int
  nonstifftol::tolType
  stifftol::tolType
  dtfac::T
  stiffalgfirst::Bool
end
AutoSwitch(nonstiffalg, stiffalg; maxstiffstep=10, maxnonstiffstep=3,
           nonstifftol=9//10, stifftol=9//10, dtfac=2, stiffalgfirst=false) =
  AutoSwitch(nonstiffalg, stiffalg, maxstiffstep, maxnonstiffstep,
             promote(nonstifftol, stifftol)..., dtfac, stiffalgfirst)

function is_stiff(integrator, alg, ntol, stol, is_stiffalg)
  eigen_est, dt = integrator.eigen_est, integrator.dt
  stiffness = abs(eigen_est*dt/alg_stability_size(alg)) # `abs` here is just for safety
  tol = is_stiffalg ? stol : ntol
  os = oneunit(stiffness)
  bool = stiffness > os * tol
  integrator.do_error_check = !bool
  bool
end

function (AS::AutoSwitchCache)(integrator)
  integrator.iter == 0 && return Int(AS.stiffalgfirst) + 1
  dt = integrator.dt
  # Successive stiffness test positives are counted by a positive integer,
  # and successive stiffness test negatives are counted by a negative integer
  AS.count = is_stiff(integrator, AS.nonstiffalg, AS.nonstifftol, AS.stifftol, AS.is_stiffalg) ?
                      AS.count < 0 ? 1 : AS.count + 1 :
                      AS.count > 0 ? -1 : AS.count - 1
  if (!AS.is_stiffalg && AS.count > AS.maxstiffstep)
    integrator.dt = dt*AS.dtfac
    AS.is_stiffalg = true
  elseif (AS.is_stiffalg && AS.count < -AS.maxnonstiffstep)
    integrator.dt = dt/AS.dtfac
    AS.is_stiffalg = false
  end
  return Int(AS.is_stiffalg) + 1
end

function AutoAlgSwitch(nonstiffalg, stiffalg; kwargs...)
  AS = AutoSwitch(nonstiffalg, stiffalg; kwargs...)
  StochasticCompositeAlgorithm((nonstiffalg, stiffalg), AS)
end

AutoSOSRI2(alg; kwargs...) = AutoAlgSwitch(SOSRI2(), alg; kwargs...)
AutoSOSRA2(alg; kwargs...) = AutoAlgSwitch(SOSRA2(), alg; kwargs...)
