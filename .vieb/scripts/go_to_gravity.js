if (location.href.includes("portal")) {
  location.href = `${location.origin}/sm/gravity`
} else if (location.href.includes("gravity")) {
  location.href = `${location.origin}/portal/app/ngsm/partner/ALL/dashboard`
}
