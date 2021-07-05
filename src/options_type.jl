mutable struct SDEOptions{tTypeNoUnits,tType,Controller,F2,F3,F4,F5,F6,F7,tstopsType,discType,ECType,SType,MI,A,R,D,
           tcache,savecache,disccache}
  maxiters::MI
  save_everystep::Bool
  adaptive::Bool
  abstol::A
  reltol::R
  gamma::tTypeNoUnits
  qmax::tTypeNoUnits
  qmin::tTypeNoUnits
  qsteady_max::tTypeNoUnits
  qsteady_min::tTypeNoUnits
  qoldinit::tTypeNoUnits
  failfactor::tTypeNoUnits
  dtmax::tType
  dtmin::tType
  controller::Controller
  internalnorm::F2
  save_idxs::SType
  tstops::tstopsType
  saveat::tstopsType
  d_discontinuities::discType
  tstops_cache::tcache
  saveat_cache::savecache
  d_discontinuities_cache::disccache
  userdata::ECType
  progress::Bool
  progress_steps::Int
  progress_name::String
  progress_message::F6
  timeseries_errors::Bool
  dense_errors::Bool
  delta::D
  dense::Bool
  save_on::Bool
  save_start::Bool
  save_end::Bool
  save_end_user::F3
  save_noise::Bool
  callback::F4
  isoutofdomain::F5
  unstable_check::F7
  verbose::Bool
  calck::Bool
  force_dtmin::Bool
  advance_to_tstop::Bool
  stop_at_next_tstop::Bool
end
